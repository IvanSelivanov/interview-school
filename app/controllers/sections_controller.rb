class SectionsController < ApplicationController
  def index
    @sections = Section.all
  end

  def enroll
    section = Section.find(params[:id])
    notice =
      if StudentSection.create(student: current_student, section: section)
       'Enrolled successfully'
      else
        'some error occured'
      end
    redirect_to sections_index_path, notice: notice
  end

  def leave
    student_section = StudentSection.find_by(section_id: params[:id], student_id: current_student.id)
    notice =
      if student_section.destroy
        'Left successfully'
      else
        'some error occured'
      end
    redirect_to sections_index_path, notice: notice
  end

  def list
    @sections = current_student.sections
  end
end
