class ApplicationController < ActionController::Base
  helper_method :current_student

  def current_student
    @current_student =
      if session[:student_id].present?
        Student.find(session[:student_id])
      else
        student = Student.create
        session[:student_id] = student.id
        student
      end
  end
end
