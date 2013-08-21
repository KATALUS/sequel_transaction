require 'spec_helper'

describe Rack::SequelTransaction do
  let(:inner) { mock }
  let(:env) { { 'field' => 'variable' } }
  let(:table_name) { :rack }
  let(:dataset) { connection[table_name] }
  let(:error) { RuntimeError.new }

  subject { Rack::SequelTransaction.new inner, connection: connection }

  before do
    connection.create_table table_name do
      column :name, String, null: false
    end
  end

  after do
    connection.drop_table table_name
    inner.verify
  end

  def expect_call(status)
    inner.expect :call, [status, {}, []] do |(environment), *args|
      dataset.insert(name: 'insert') if args.empty? && environment == env
    end
  end

  it 'returns result' do
    expect_call 200
    result = subject.call(env)
    result.must_equal [200, {}, []]
  end

  it 'wont rollback when ok' do
    expect_call 200
    subject.call env
    dataset.wont_be :empty?
  end

  it 'wont roll back on redirect' do
    expect_call 301
    subject.call env
    dataset.wont_be :empty?
  end

  it 'rolls back if sinatra exception' do
    expect_call 200
    env['sinatra.error'] = StandardError.new 'snap'
    subject.call env
    dataset.must_be :empty?
  end

  it 'rolls back on server error' do
    expect_call 500
    subject.call env
    dataset.must_be :empty?
  end

  it 'rolls back on client error' do
    expect_call 400
    subject.call env
    dataset.must_be :empty?
  end
end
