module MeetingsHelper
    def generate_code
        ('a'...'z').to_a.shuffle[0..7].join
    end

    def generate_password
        (0..9).to_a.shuffle[0..4].join
    end
end
