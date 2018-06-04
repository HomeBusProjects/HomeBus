module ApplicationHelper

  def flash_class(level)
    case level
        when "primary" then "alert alert-primary"

        when "secondary" then "alert alert-secondary"

        when "success" then "alert alert-success"

        when "danger" then "alert alert-danger"
        when "error" then "alert alert-dangerr"
        when "alert" then "alert alert-danger"

        when "warning" then "alert alert-warning"

        when "info" then "alert alert-info"
        when "notice" then "alert alert-info"

        when "light" then "alert alert-light"

        when "dark" then "alert alert-dark"

        else "alert alert-info"
    end
  end
end
