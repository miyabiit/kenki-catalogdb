require 'csv'

class ImportBase
  def parse_csv(csv_file)
    CSV.read(csv_file, headers: true)
  end

  def import(csv_file)
    failed_instances = []
    ApplicationRecord.transaction do
      csv = CSV.read(csv_file, headers: true, encoding: "CP932:UTF-8")
      failed_instances = process_csv(csv.map{|row| row.to_h })
      if failed_instances.present?
        raise ActiveRecord::Rollback
      end
    end
    failed_instances
  end

  def process_csv(csv)
    raise 'Must be implement!'
  end
end
