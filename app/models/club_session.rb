class ClubSession < Authlogic::Session::Base
  authenticate_with Club
end