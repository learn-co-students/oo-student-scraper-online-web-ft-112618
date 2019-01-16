class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  def initialize(student_hash)
     @name = student_hash.fetch(:name)
     @location = student_hash.fetch(:location)
     @@all << self
  end

  def self.create_from_collection(students_array)
    students_array.each do |new_student|
      self.new(new_student)
     end 
  end

  def add_student_attributes(attributes_hash)
    @twitter = attributes_hash.fetch(:twitter)
    @linkedin = attributes_hash.fetch(:linkedin)
    @github = attributes_hash.fetch(:github)
    @blog = attributes_hash.fetch(:blog)
    @profile_quote = attributes_hash.fetch(:profile_quote)
    @bio = attributes_hash.fetch(:bio)
  end

  def self.all
    @@all
  end
end

