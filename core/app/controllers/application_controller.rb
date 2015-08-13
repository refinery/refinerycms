# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  before_filter :format_dates_and_times, only: [:update, :create]

  def format_dates_and_times
    simpleClassName = controller_name.classify
    arrayForNamespace = self.class.name.split("::")

    # Make a string that contains the name of the corresponding model for this controller with its namespace.
    className = "#{arrayForNamespace[0]}::#{arrayForNamespace[1]}::#{simpleClassName}"
    classNameUnderscored = simpleClassName.demodulize.underscore
    unless defined?(className.constantize.columns)
      return # return early if this controller doesn't have a corresponding model
    end
    # Get all properties for this class that are either a datetime, date or time property
    datetimefields =  className.constantize.columns.reject{|column| !(['datetime', 'date', 'time'].include? column.sql_type)}
    # Iterate over the fields and format date and time parameters appropriately according to what the datetimepicker is sending.
    datetimefields.each do |dt|
      if params[classNameUnderscored.to_sym][dt.name.to_sym].present?
        date = params[classNameUnderscored.to_sym][dt.name.to_sym][:date]
        time = params[classNameUnderscored.to_sym][dt.name.to_sym][:time]

        if date.present? && time.present?
          datetime = DateTime.strptime("#{date} #{time}", '%m/%d/%Y %H:%M %P')
        elsif date.present?
          datetime =  Date.strptime(date, '%m/%d/%Y')
        elsif time.present?
          datetime =  Time.strptime(time, '%H:%M %P')
        end
        # Delete whatever was initially passed
        params[classNameUnderscored.to_sym].delete dt.name.to_sym
        # Assign the formatted date, time or datetime to the param
        params[classNameUnderscored.to_sym][dt.name.to_sym] = datetime
      end
    end
  end
end
