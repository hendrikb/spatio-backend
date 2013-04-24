# encoding: UTF-8

class Reader::CSV::WlanStandorteBerlin
  include Reader

  def initialize file_name
    super
    @file_name = file_name
  end

  def load

    @csv = ::CSV.foreach @file_name, col_sep:';',headers: :first_row, encoding: "windows-1252:UTF-8" do |row|
      @items << generate_item(row)
    end
    add_ids
  end

  private
  def generate_item row
    {
        human_readable_location_in: "#{row[0]} #{row[1]} #{row[2]} #{row[3]}",
        meta_data: {
          bezirk: row[0],
          standort: row[1],
          strasse: row[2],
          plz: convert_plz(row[3]),
          strasse2: row[4],
          plz2: convert_plz(row[5]),
          ort: row[6],
          kostenfrei: begin convert_answer_to_bool(row[7]) rescue nil end,
          betreiber: row[8],
          versorgnungsbereich: row[9],
        }
      }
  end

  def convert_answer_to_bool answer
    answer.upcase == "J"
  end

  def convert_plz plz
    return nil if plz.nil?
    plz.to_i
  end
end
