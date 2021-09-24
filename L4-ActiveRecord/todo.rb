require 'active_record'
class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{display_status} #{todo_text} #{display_date}"
  end

  def self.to_displayable_list
    all.map {|todo| todo.to_displayable_string }
  end
  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    todo_overdue= where("due_date < ?",Date.today)
    puts todo_overdue.to_displayable_list

    puts "\n\n"
    puts "Due Today\n"
    todo_due_today= where("due_date = ?",Date.today)
    puts todo_due_today.to_displayable_list
    puts "\n\n"

    puts "Due Later\n"
    todo_due_later= where("due_date > ?",Date.today)
    puts todo_due_later.to_displayable_list
    puts "\n\n"
  end

  def self.add_task(todo_hash)
    create(todo_text: todo_hash[:todo_text],due_date: Date.today + todo_hash[:due_in_days],completed: false)
  end

  def self.mark_as_complete(todo_id)
    todo_new=find(todo_id)
    todo_new.completed=true
    todo_new.save
    todo_new
  end
end
