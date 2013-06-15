module ScriptsHelper
  def script_options_for_select(scripts, base_dir = nil)
    options_for_select scripts.map { |script| [script, script_path(script, base_dir)] }
  end

  private

    def script_path(script, base_dir)
      base_dir.nil? ? script : File.join(base_dir, script)
    end
end
