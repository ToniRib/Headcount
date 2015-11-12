class FileRepo

  attr_reader :processor, :files

  def initialize
    @processor = Preprocessor.new
    @files = {}
  end

  def load_file(file)
    files[file] = processor.pull_from_CSV(file)
  end

end
