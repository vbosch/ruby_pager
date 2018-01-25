require 'nokogiri'
require 'nori'
require 'ap'
module RubyPager


  class XML
    def self.exists?(file_name)
      if file_name.end_with?(".xml")
        return File.file?(file_name)
      end
      return false
    end

    def self.load(file_name)
      if self.exists?(file_name)
        xml  = Nokogiri::XML(File.open(file_name)) { |config| config.strict.noblanks }
        hash = Nori.new(:parser => :nokogiri, :advanced_typecasting => false).parse(xml.to_s)
        return hash
      end
      return nil
    end

    def self.save(file_name,hash)
      File.open(file_name, 'w') { |file| file.write(self.generate_xml(hash)) } ;
    end

    def self.generate_xml(data, parent = false, opt = {})
      return if data.to_s.empty?
      return unless data.is_a?(Hash)

      unless parent
        # assume that if the hash has a single key that it should be the root
        root, data = (data.length == 1) ? data.shift : ["root", data]
        attr = Hash.new
        data.each{|label,value|
          if(label.start_with?("@")) then
            new_label = label.dup
            new_label[0]= ''
            attr[new_label]=value
          end
        }
        #attr["xmlns_xsi"] = data.fetch('@xmlns:xsi', {})
        #attr["xmlns"] = data.fetch('@xmlns', {})
        #attr["xsi_schemaLocation"] = data.fetch('@xsi:schemaLocation', {})
        #attr["pcGtsId"] = data.fetch('@pcGtsId', {})
        builder = Nokogiri::XML::Builder.new(opt) do |xml|
          xml.send(root,attr) {
            #data.delete('@xmlns:xsi')
            #data.delete('@xmlns')
            #data.delete('@xsi:schemaLocation')
            #data.delete('@pcGtsId')
            data.each{|label,value|
              if(label.start_with?("@")) then
                data.delete(label)
              end
            }
            generate_xml(data, xml)
          }
        end

        return builder.to_xml
      end
      data.each { |label, value|
        if value.is_a?(Hash)
          attr = Hash.new
          value.each{|vlabel,vvalue|
            if(vlabel.start_with?("@")) then
              new_label = vlabel.dup
              new_label[0]= ''
              attr[new_label]=vvalue
            end
          }

          # also passing 'text' as a key makes nokogiri do the same thing
          parent.send(label,attr) {
            value.each{|vlabel,vvalue|
              if(vlabel.start_with?("@")) then
                value.delete(vlabel)
              end
            }
            #ap value
            #sleep(10)
            generate_xml(value, parent)
          }

        elsif value.is_a?(Array)
          value.each { |el|
            # lets trick the above into firing so we do not need to rewrite the checks
            el = {label => el}
            generate_xml(el, parent)
          }

        else
          parent.send(label, value)
        end
      }
    end
  end

end