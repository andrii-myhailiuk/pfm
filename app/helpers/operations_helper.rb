module OperationsHelper
  # Method for time localization
  def format_datetime(strdatetime)
    I18n.l(strdatetime.to_time, format: :long)
  end
end
