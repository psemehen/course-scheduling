# Clear existing data
puts "Clearing existing data..."
[Enrollment, Section, Student, Teacher, Subject, Classroom].each(&:delete_all)

# Create Subjects
puts "Creating subjects"
subjects = [{name: "Math"}, {name: "Physics"}].map { |subject| Subject.create!(subject) }

puts "Creating classrooms"
classrooms = [{name: "Room 1", capacity: 40}, {name: "Room 2", capacity: 30}]
  .map { |classroom| Classroom.create!(classroom) }

# Create Teachers
puts "Creating teachers"
teachers = [
  {first_name: "Test", last_name: "Teacher1", email: "teacher1@gmail.com"},
  {first_name: "Test", last_name: "Teacher2", email: "teacher2@gmail.com"}
].map { |teacher| Teacher.create!(teacher) }

# Create Students
puts "Creating students"
students = [
  {first_name: "Test", last_name: "Student1", email: "student1@gmail.com"},
  {first_name: "Test", last_name: "Student2", email: "student2@gmail.com"}
].map { |student| Student.create!(student) }

# Create Sections
puts "Creating sections"
sections =
  [
    {start_time: "2025-06-01 09:00:00",
     end_time: "2025-06-01 09:50:00",
     duration: 50,
     days_of_week: :mon_wed_fri,
     teacher: teachers.first,
     subject: subjects.first,
     classroom: classrooms.first},
    {start_time: "2025-06-01 10:00:00",
     end_time: "2025-06-01 11:20:00",
     duration: 80,
     days_of_week: :everyday,
     teacher: teachers.second,
     subject: subjects.second,
     classroom: classrooms.second}
  ].map { |section| Section.create!(section) }

# Create enrollments
puts "Creating enrollments"
students.each do |student|
  sections.each do |section|
    Enrollment.create!(
      grade: %w[A B C D F].sample,
      subject: section.subject,
      student: student,
      section: section
    )
  end
end
