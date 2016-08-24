# frozen_string_literal: true
class GitHubRepository < GitHubResource
  def add_collaborator(collaborator, options = {})
    GitHub::Errors.with_error_handling do
      @client.add_collaborator(@id, collaborator, options)
    end
  end

  def get_starter_code_from(source)
    GitHub::Errors.with_error_handling do
      credentials = { vcs_username: @client.login, vcs_password: @client.access_token }
      @client.start_source_import(@id, 'git', "https://github.com/#{source.full_name}", credentials)
    end
  end

  def present?(**options)
    self.class.present?(@client, @id, options)
  end

  def releases(**options)
    GitHub::Errors.with_error_handling do
      @client.releases(@id, options)
    end
  end

  def self.present?(client, full_name, **options)
    client.repository?(full_name, options)
  end

  def self.find_by_name_with_owner!(client, full_name)
    GitHub::Errors.with_error_handling do
      repository = client.repository(full_name)
      GitHubRepository.new(client, repository.id)
    end
  end

  private

  def attributes
    %w(name full_name html_url)
  end
end
