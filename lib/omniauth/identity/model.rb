# frozen_string_literal: true

module OmniAuth
  module Identity
    # This module provides an includable interface for implementing the
    # necessary API for OmniAuth Identity to properly locate identities
    # and provide all necessary information. All methods marked as
    # abstract must be implemented in the including class for things to
    # work properly.
    module Model
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # Locate an identity given its unique login key.
        #
        # @abstract
        # @param [String] key The unique login key.
        # @return [Model] An instance of the identity model class.
        def locate(key)
          raise NotImplementedError
        end

        # Authenticate a user with the given key and password.
        #
        # @param [String] key The unique login key provided for a given identity.
        # @param [String] password The presumed password for the identity.
        # @return [Model] An instance of the identity model class.
        def authenticate(conditions, password)
          instance = locate(conditions)
          return false unless instance

          instance.authenticate(password)
        end

        # Used to set or retrieve the method that will be used to get
        # and set the user-supplied authentication key.
        # @return [String] The method name.
        def auth_key(method = false)
          @auth_key = method.to_s unless method == false
          @auth_key = nil if !defined?(@auth_key) || @auth_key == ''

          @auth_key || 'email'
        end
      end

      # Returns self if the provided password is correct, false
      # otherwise.
      #
      # @abstract
      # @param [String] password The password to check.
      # @return [self or false] Self if authenticated, false if not.
      def authenticate(password)
        raise NotImplementedError
      end

      SCHEMA_ATTRIBUTES = %w[name email nickname first_name last_name location description image phone].freeze
      # A hash of as much of the standard OmniAuth schema as is stored
      # in this particular model. By default, this will call instance
      # methods for each of the attributes it needs in turn, ignoring
      # any for which `#respond_to?` is `false`.
      #
      # If `first_name`, `nickname`, and/or `last_name` is provided but
      # `name` is not, it will be automatically calculated.
      #
      # @return [Hash] A string-keyed hash of user information.
      def info
        SCHEMA_ATTRIBUTES.each_with_object({}) do |attribute, hash|
          hash[attribute] = send(attribute) if respond_to?(attribute)
        end
      end

      # An identifying string that must be globally unique to the
      # application. Defaults to stringifying the `id` method.
      #
      # @return [String] An identifier string unique to this identity.
      def uid
        if respond_to?(:id)
          return nil if id.nil?

          id.to_s
        else
          raise NotImplementedError
        end
      end

      # Used to retrieve the user-supplied authentication key (e.g. a
      # username or email). Determined using the class method of the same name,
      # defaults to `:email`.
      #
      # @return [String] An identifying string that will be entered by
      #   users upon sign in.
      def auth_key
        if respond_to?(self.class.auth_key.to_sym)
          send(self.class.auth_key)
        else
          raise NotImplementedError
        end
      end

      # Used to set the user-supplied authentication key (e.g. a
      # username or email. Determined using the `.auth_key` class
      # method.
      #
      # @param [String] value The value to which the auth key should be
      #   set.
      def auth_key=(value)
        auth_key_setter = "#{self.class.auth_key}=".to_sym
        if respond_to?(auth_key_setter)
          send(auth_key_setter, value)
        else
          raise NotImplementedError
        end
      end
    end
  end
end
