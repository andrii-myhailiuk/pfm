class Operation < ApplicationRecord
  belongs_to :category
  validates :amount, numericality: { greater_than: 0 }
  validates :odate, presence: true
  validates :description, presence: true
  validates :otype, presence: true

  enum otype: {
    income: 10,
    passive_income: 20,
    special_income: 30,
    expense: 40,
    special_expense: 50,
    state_expense: 60,
    charity: 70
  }

  # Set of methods for creating Report
  def self.otype_filter(otype)
    where(otype: otype)
  end

  def self.category_id_filter(category_id)
    where(category_id: category_id)
  end

  def self.start_date_filter(start_date)
    where('odate >= ?', start_date.to_time.beginning_of_day)
  end

  def self.end_date_filter(end_date)
    where('odate <= ?', end_date.to_time.end_of_day)
  end

  def self.create_report_by_categories(params)
    filtered_operations = self.operations_filter(params)
    dates = [filtered_operations.minimum(:odate).to_date, filtered_operations.maximum(:odate).to_date]
    report = filtered_operations.joins(:category).group("categories.name").sum('CAST(amount AS DECIMAL(10,2))')
    { dates: dates, report: report }
  end

  def self.create_report_by_dates(params)
    filtered_operations = self.operations_filter(params)
    dates = [filtered_operations.minimum(:odate).to_date, filtered_operations.maximum(:odate).to_date]
    # report = filtered_operations.group('DATE(odate), category_id').sum('CAST(amount AS DECIMAL(10,2))')
    # report = filtered_operations.joins(:category).group('DATE(operations.odate)', 'categories.name').sum('CAST(amount AS DECIMAL(10,2))')
    data = filtered_operations.joins(:category).group('DATE(operations.odate)', 'categories.name').sum('CAST(amount AS DECIMAL(10,2))')

    # Отримуємо унікальний список категорій з масиву даних
    categories = data.keys.map(&:last).uniq

    # Створюємо порожні масиви для майбутніх даних
    datasets = []
    categories.each do |category|
      dataset = { 
        label: category, # мітка категорії
        data: [], # дані категорії
        borderColor: "rgb(#{rand(0..255)}, #{rand(0..255)}, #{rand(0..255)})", # кольори для кожної категорії (випадково)
        fill: false # вимикаємо заповнення для кожної лінії
      }
      datasets << dataset
    end

    # Наповнюємо дані для кожного датасету
    labels = data.keys.map(&:first).uniq.sort # Отримуємо унікальні дати з масиву даних та сортуємо їх
    labels.each do |label|
      categories.each do |category|
        amount = data[[label, category]] || 0 # Отримуємо значення, якщо воно є, інакше - 0
        datasets.find { |dataset| dataset[:label] == category }[:data] << amount # Додаємо значення до відповідного датасету
      end
    end

    # Створюємо головний хеш з даними для графіка
    chart_data = {
      labels: labels,
      datasets: datasets
    }
    # byebug
    # { dates: dates, report: report }
  end

  private
  # returns filtered operations depending of given params
  def self.operations_filter(params)
    permitted_params = [:category_id, :otype, :start_date, :end_date]
    report = self
    permitted_params.each do |param|
      if params[param] != ''
        # calls methods from models/operation.rb
        report = report.send("#{param.to_s}_filter", params[param])
      end
    end
    report
    # rr = report.group('DATE(odate)').sum('CAST(amount AS DECIMAL(10,2))')
    # rr = report.select(:name, :amount).group(:name).sum('CAST(amount AS DECIMAL(10,2))')
    # rr = report.joins(:category).group("categories.name").sum('CAST(amount AS DECIMAL(10,2))')
    # dates = [report.minimum(:odate).to_date, report.maximum(:odate).to_date]
  end

end
