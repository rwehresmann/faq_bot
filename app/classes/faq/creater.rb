module Faq
  class Creater
    include Utils

    def initialize(args = {})
      @question = args[:question]
      @answer = args[:answer]
      @tags = args[:tags]
    end

    def call
      [:question, :answer, :tags].each { |arg|
        return error_hash(arg) unless valid_arg?(arg)
      }

      ActiveRecord::Base.transaction do
        question = Question.create!(description: @question)
        Answer.create!(content: @answer, question: question)
        split_tags(@tags).each do |tag|
          tag_obj = Tag.find_or_create_by!(name: tag)
          question.add_tag(tag_obj) 
        end
      end

      success_hash
    end

    private

    def valid_arg?(arg)
      arg = instance_variable_get("@#{arg}")
      true unless arg == nil || arg.empty?
    end
  end
end
