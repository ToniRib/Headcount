class FileRepo

  attr_accessor :kindergarten_participation, :high_school_graduation
  attr_reader :processor

  def initialize
    @processor = Preprocessor.new
  end

  def load_file(file)
      file_name_instance_converter[file][processor.pull_from_CSV(file)]
  end

  def file_name_instance_converter
    { "./test/fixtures/kindergarten_tester.csv" =>  kindergarten_loader,
      "./test/fixtures/highschool_grad_tester.csv" => high_school_grad_loader}
  end

  def kindergarten_loader
    lambda {|processed_file| self.kindergarten_participation = processed_file}
  end

  def high_school_grad_loader
    lambda {|processed_file| self.high_school_graduation = processed_file}
  end

end
