require 'json'

class ReportsController < ApplicationController
  def index
    @category_options = Category.all.map { |category| [category.name, category.id] }
    @otypes_options = Operation.otypes.map {|k, v| [t(k.to_sym), k]}
  end

  def report_by_category
    result = Operation.create_report_by_categories(params)
    @dates = result[:dates]
    @labels = result[:report].keys
    @data = result[:report].values
    @expenses_sum = @data.sum
    @chart_type = 'pie'

    respond_to do |format|
      format.html { render :report_by_category }
      format.turbo_stream { render :report_by_category }
    end
  end

  def report_by_dates
    @data = Operation.create_report_by_dates(params)
    @data = @data.to_json
    @chart_type = 'line'
    byebug

    # @dates = result[:dates]
    # @labels = result[:report].keys
    # @data = result[:report].values
    # @expenses_sum = @data.sum
    # @chart_type = 'line'

    respond_to do |format|
      format.html { render :report_by_dates, params: params }
      format.turbo_stream { render :report_by_category }
    end
  end

  private
  def create_report
    # permitted_params = [:category_id, :otype, :start_date, :end_date]
    # report = Operation
    # permitted_params.each do |param|
    #   if params[param] != ''
    #     # calls methods from models/operation.rb
    #     report = report.send("#{param.to_s}_filter", params[param])
    #   end
    # end
    # # rr = report.group('DATE(odate)').sum('CAST(amount AS DECIMAL(10,2))')
    # # rr = report.select(:name, :amount).group(:name).sum('CAST(amount AS DECIMAL(10,2))')
    # rr = report.joins(:category).group("categories.name").sum('CAST(amount AS DECIMAL(10,2))')
    # dates = [report.minimum(:odate).to_date, report.maximum(:odate).to_date]
    # byebug
    # rr
    # #
  end

  # Only allow a list of trusted parameters through.
  def report_params
    params.permit(:start_date, :end_date, :otype, :category_id)
  end
end

#<ActionController::Parameters 
# {"authenticity_token"=>"V6aCI_t1XIJL5E_4FuOEsTOHA9ebdq_lC46CYgGEZ6d_AJGXbsWcIjYXxPIlCcMp7NbI7fEuuLiRJ7j8Fvbilg", 
# "operation"=>#<ActionController::Parameters {"amount"=>"44", "description"=>"Test", "otype"=>"expense", 
# "odate"=>"2023-01-29T16:30", "category_id"=>"1"} permitted: false>, "commit"=>"Create", "controller"=>"operations", 
# "action"=>"create"} permitted: false>