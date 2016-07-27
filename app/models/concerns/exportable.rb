module Exportable
  extend ActiveSupport::Concern

  module ClassMethods
    def to_csv attributes
      CSV.generate(headers: true) do |csv|
        csv << attributes

        all.each do |object|
          csv << attributes.map{|attr| object.send(attr)}
        end
      end
    end

    def to_excel attributes
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet

      sheet.row(0).concat attributes
      all.each_with_index do |object, index|
        sheet.row(index+1).concat attributes.map{|attr| object.send(attr)}
      end

      download_path = "public/download/#{Date.today}.xls"
      book.write download_path
      return download_path
    end
  end
end
