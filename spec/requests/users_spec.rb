require 'swagger_helper'
require 'byebug'

describe 'User API', type: :request do
  let(:current_token) { Token.create(scopes: %w[tokens:write users:owners])}
  let(:current_user) { User.find_or_create_by(name: 'test', email: 'test@test.com', token: current_token)}
  let(:Authorization) { "Bearer #{current_user.token.value}"}

  path '/users' do
    post 'Create a new user' do
      consumes 'application/json'
      tags 'Users'
      description 'Create a user. No token is necessary.'
      
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Liam'},
          email: {type: :string, example: 'liam@weather-alert.com'}
        },
        required: %w[name, email]
      }

      response '200', 'success' do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        let(:user) { { name: 'liam1', email: 'liam1@weather-alert.com'} }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to be_truthy
          expect(data['name']).to eq('liam1')
          expect(data['email']).to eq('liam1@weather-alert.com')
          expect(data['token']['id']).to be_truthy
          expect(data['token']['value']).to be_truthy
        end
      end

      response '400', 'Incorrect data provided (Incorrent email or missing parameters)' do
        let(:user) { { name: 'liam1', email: 'jlb' } }
        run_test!
        let(:user) { { name: 'email missing' } }
        run_test!
      end
    end
  end

  path '/users/{id}' do
    get 'Get User Info' do
      consumes 'application/json'
      tags 'Users'
      security [bearerAuth: ['users:owner']]
      parameter name: :id, in: :path, type: :string
      description "Get User's info. Must have `users:owner` scope."

      response '200', 'success' do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        let(:id) { current_user.id }
        run_test!
      end

      response '403', 'Incorrect user id provided' do
        let(:id) { 42 }
        run_test!
      end

      response '401', 'Invalid Token' do
        let(:id) { current_user.id }
        let(:Authorization) { 'Bearer XXX' }
        run_test!
      end
    end
  end

  path '/users/{id}' do
    put 'Update User info' do
      consumes 'application/json'
      tags 'Organizations'
      security [bearerAuth: ['users:owner']]
      description 'Update Users info. You must have an API token with the `users:owner` scope in order to use this.'

      parameter name: :id, in: :path, type: :string

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Liam'},
          email: {type: :string, example: 'liam@weather-alert.com'}
        }
      }

      response '200', 'success' do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        let(:id) { current_user.id }
        let(:user) { { name: 'liam b', email: 'product@weather-alert.com' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('liam b')
          expect(data['email']).to eq('product@weather-alert.com')
        end
      end

      response '403', 'Access Denied' do
        context 'Incorrect user id provided' do
          let(:id) { 23 }
          let(:user) { { name: 'liam b', email: 'product@weather-alert.com' } }

          run_test!
        end
      end

      response '401', 'Invalid Token' do
        let(:id) { current_user.id }
        let(:Authorization) { 'Bearer XXX' }
        let(:user) { { name: 'liam b', email: 'product@weather-alert.com' } }

        run_test!
      end
    end
  end
end
