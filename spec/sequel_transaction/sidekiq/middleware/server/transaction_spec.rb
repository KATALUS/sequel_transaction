require 'spec_helper'
require 'sequel_transaction/sidekiq'

describe Sidekiq::Middleware::Server::Transaction do
  let(:table_name) { :sidekiq }
  let(:dataset) { connection[table_name] }
  let(:error) { RuntimeError.new }

  subject { Sidekiq::Middleware::Server::Transaction.new connection: connection }

  before do
    connection.create_table table_name do
      column :name, String, null: false
    end
  end

  after { connection.drop_table table_name }

  it 'commits transaction' do
    subject.call do
      dataset.insert name: 'first'
      dataset.insert name: 'second'
    end
    dataset.count.must_equal 2
  end

  it 'rolls back transaction' do
    actual_error = nil
    begin
      subject.call do
        dataset.insert name: 'first'
        raise error
      end
    rescue => e
      actual_error = e
    end
    dataset.count.must_equal 0
    actual_error.must_equal error
  end
end
