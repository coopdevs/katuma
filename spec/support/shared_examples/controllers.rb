shared_examples 'a successful request' do

  describe 'response is success' do

    it 'responds with a 200 status code' do
      subject

      expect(response).to have_http_status(200)
    end
  end
end

shared_examples 'a successful request (201)' do

  describe 'response is success (201)' do

    it 'responds with a 201 status code' do
      subject

      expect(response).to have_http_status(201)
    end
  end
end

shared_examples 'a successful request (204)' do

  describe 'response is success (204)' do

    it 'responds with a 204 status code' do
      subject

      expect(response).to have_http_status(204)
    end
  end
end

shared_examples 'an unauthorized request' do

  describe 'response is unauthorized' do

    it 'responds with a 401 status code' do
      subject

      expect(response).to have_http_status(401)
    end
  end
end

shared_examples 'a forbidden request' do

  describe 'response is forbidden' do

    it 'responds with a 403 status code' do
      subject

      expect(response).to have_http_status(403)
    end
  end
end

shared_examples 'a not found request' do

  describe 'response is not found request' do

    it 'responds with a 404 status code' do
      subject

      expect(response).to have_http_status(404)
    end
  end
end

shared_examples 'a bad request' do

  describe 'response is bad request' do

    it 'responds with a 400 status code' do
      subject

      expect(response).to have_http_status(400)
    end
  end
end

shared_examples 'response with empty body' do

  describe 'response body is empty' do
    its(:body) { is_expected.to eq(' ') }
  end
end
