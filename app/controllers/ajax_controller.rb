class AjaxController < ApplicationController
  skip_before_filter :authenticate_user!
  def specialities
    render({ json: Speciality.from_faculty(params[:faculty]).inject([]) do |specialities, speciality|
      specialities << { id: speciality.id, code: speciality.code, name: speciality.name }
      specialities
    end })
  end

  def groups
    render({ json: Group.filter(params).inject([]) do |groups, group|
      groups << { id: group.id, name: group.name }
      groups
    end })
  end

  def disciplines
    render({ json: Study::Discipline.where(subject_year: 2013).from_name(params[:discipline_name]).inject([]) do |disciplines, discipline|
      teachers = []
      discipline.teachers.each do |teacher|
        teachers << teacher.full_name
      end
      disciplines << { id: discipline.id, name: discipline.name, term: discipline.term,
                       groups: discipline.group.name, teachers: teachers.join(', '),
                        }
      disciplines
    end })
  end

  def subjects
    render({ json: Study::Subject.from_name(params[:subject_name]).from_group(params[:subject_group]).inject([]) do |subjects, subject|
      subjects << { id: subject.id, title: subject.title, year: subject.year,
                       semester: subject.semester, type: subject.type,
                       group: subject.group.name }
      subjects
    end })
  end

  def students
    render({ json: Student.filter(group: params[:group]).inject([]) do |students, student|
      students << { id: student.id, name: student.person.full_name }
      students
    end })
  end

  def checkpoint
    x = Study::Checkpoint.find(params[:checkpoint_id])
    checkpoint = {type: x.checkpoint_type, date: x.date.strftime("%d.%m.%Y"), name: x.name,
                  details: x.details, day: x.date}
    render({ json: checkpoint })
  end

  def users
    render({ json: User.filter(params).inject([]) do |users, user|
      users << { id: user.id, name: user.full_name, positions: user.positions.collect{|position| position.title}.push(user.user_position == nil ? [] : user.user_position.split(', ')).flatten.uniq.join(', '),
                username: user.username, phone: (user.phone == nil ? '' : user.phone),
                departments: (user.departments.collect{|department| department.abbreviation} << (Department.find(user.user_department).abbreviation if Department.exists?(user.user_department))).uniq.join(', ')
                                  }
      users
    end })
  end

  def positions
    respond_to do |format|
      format.js
    end
  end
end