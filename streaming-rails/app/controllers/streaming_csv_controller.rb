class StreamingCsvController < ApplicationController
  private def load_averages
    `uptime`.split(' ')[-3..-1].map(&:to_f)
  end

  # CSV unidirectional streaming example.
  #
  # Outputs a CSV with the 1m, 5m, and 15m load averages every second.
  #
  # > curl http://localhost:3000/streaming_csv/output
  # Time,1m Load Average,5m Load Average,15m Load Average
  # 2024-11-01 01:17:19 +1300,2.35,2.09,2.21
  # 2024-11-01 01:17:20 +1300,2.35,2.09,2.21
  # 2024-11-01 01:17:21 +1300,2.35,2.09,2.21
  # 2024-11-01 01:17:22 +1300,2.64,2.16,2.23
  # 2024-11-01 01:17:23 +1300,2.64,2.16,2.23
  # 2024-11-01 01:17:24 +1300,2.64,2.16,2.23
  # 2024-11-01 01:17:25 +1300,2.64,2.16,2.23
  # 2024-11-01 01:17:27 +1300,2.64,2.16,2.23
  def output
    body = proc do |stream|
      csv = CSV.new(stream)
      
      csv << ['Time', '1m Load Average', '5m Load Average', '15m Load Average']
      
      while true
        csv << [Time.now.to_s, *load_averages]
        sleep(1)
      end
    rescue => error
    ensure
      stream.close(error)
    end
    
    self.response = Rack::Response[200, {'content-type' => 'text/csv'}, body]
  end
  
  skip_before_action :verify_authenticity_token, only: :input
  
  # CSV bidirectional streaming example.
  #
  # Reads a CSV with a list of numbers and outputs a CSV with the minimum, maximum, and average of each row.
  #
  # > curl -X POST -d "1,2,3" -H "content-type: text/csv" http://localhost:3000/streaming_csv/input
  # Minimum,Maximum,Average
  # 1.0,3.0,2.0
  def input
    body = proc do |stream|
      csv = CSV.new(stream)
      
      csv << ['Minimum', 'Maximum', 'Average']
      
      csv.each do |row|
        numbers = row.map(&:to_f)
        minimum, maximum = numbers.minmax
        average = numbers.sum / numbers.size
        
        csv << [minimum, maximum, average]
      end
    rescue => error
    ensure
      stream.close(error)
    end
    
    self.response = Rack::Response[200, {'content-type' => 'text/csv'}, body]
  end
end
