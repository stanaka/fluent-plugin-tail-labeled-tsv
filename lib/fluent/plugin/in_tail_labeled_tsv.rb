module Fluent


class TailLabeledTSVInput < TailInput
  Plugin.register_input('tail_labeled_tsv', self)

  def configure_parser(conf)
    @parser = TextParser.new
  end

  def parse_line(line)

    record = Hash.new
    columns = line.split("\t")
    columns.each do |c|
      (k, v) = c.split(":", 2)
      record[k] = v
    end

    if value = record.delete(@time_key)
      if @time_format
        time = Time.strptime(value, @time_format).to_i
      else
        time = value.to_i
      end
    else
      time = Engine.now
    end

    return time, record
  end

end

end
