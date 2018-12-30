require "pry"
class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url

  @@all = []

  def initialize(student_hash)

    student_hash.each do |method, student_data|
      self.send("#{method.to_s}=", student_data) #if self.respond_to?("#{method.to_s}=")
    end

    @@all << self
  end

  def self.create_from_collection(students_array)
    students_array.each do |student|
      Student.new(student)
    end
  end

  def add_student_attributes(attributes_hash)

    attributes_hash.each do |method, student_data|
      self.send("#{method.to_s}=", student_data)
    end
  end

  def self.all
    @@all
  end
end
