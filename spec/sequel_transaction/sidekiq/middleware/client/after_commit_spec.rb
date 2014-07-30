require 'spec_helper'
require 'sequel_transaction/sidekiq'

describe Sidekiq::Middleware::Client::AfterCommit do
  let(:worker_class) { mock }
  let(:msg) { mock }
  let(:queue) { mock }
  let(:table_name) { :sidekiq }
  let(:dataset) { connection[table_name] }
  let(:error) { RuntimeError.new }

  subject { Sidekiq::Middleware::Client::AfterCommit.new connection: connection }

  before do
    connection.create_table table_name do
      column :name, String, null: false
    end
  end

  after { connection.drop_table table_name }

  it 'defers yield until after committing a transaction' do
    called = false
    connection.transaction do
      subject.call worker_class, msg, queue do
        called = true
      end
      called.must_equal false
    end
    called.must_equal true
  end

  it 'yields immediately without transaction' do
    called = false
    subject.call worker_class, msg, queue do
      called = true
    end
    called.must_equal true
  end

  it 'does not yield after failing to commit transaction' do
    called = false
    begin
      connection.transaction do
        subject.call worker_class, msg, queue do
          called = true
        end
        raise
      end
    rescue
    end
    called.must_equal false
  end
end
