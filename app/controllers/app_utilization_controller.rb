class AppUtilizationController < ApplicationController
  def cpu
    @instance_group = params[:instance_group]
    @app_id = params[:app_id]
    @instance_type = params[:instance_type].blank? ? 'C' : params[:instance_type]
    @visits = Visit.all
    @cpu = CpuUtilization.find_by_sql(<<-eos
    select _c1 as team, _c3 as date, sum(_c6) as total, _c5 as instance_group,
           sum(ROUND(((_c7*0.1)+(_c8*0.2)+(_c9*0.3)+(_c10*0.4)+(_c11*0.5)+(_c12*0.6)+(_c13*0.7)+(_c14*0.9)+(_c15*0.9)+(_c16)))) as actual,
           (sum((ROUND(((_c7*0.1)+(_c8*0.2)+(_c9*0.3)+(_c10*0.4)+(_c11*0.5)+(_c12*0.6)+(_c13*0.7)+(_c14*0.9)+(_c15*0.9)+(_c16)))*100))/sum(_c6)) as perc_utilization
           from cpu_utilizations
           where _c1 like '%#{@app_id}%' and _c5 like '%#{@instance_group}%' and
           machine_type='#{@instance_type}' group by date
    eos
    )
    total_data = {}
    actual_data = {}
    @utilization_perc = {}
    @cpu.each do |cpu_info|
      total_data["#{cpu_info.date}"] = cpu_info.total
      actual_data["#{cpu_info.date}"] = cpu_info.actual
      @utilization_perc["#{cpu_info.date}"] = cpu_info.perc_utilization
    end
    @cpu_data = [{:name => 'allocated', :data => total_data},{:name => 'utilized', :data => actual_data}]
  end

  def disk
  end

  def network

  end

  def error_page
    error_input = 'Please provide ap_id, instance_group in the params e.g - ?app_id=apl&instance_group=invoice-register'
    render html: error_input.html_safe
  end
end
