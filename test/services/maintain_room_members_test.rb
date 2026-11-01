# frozen_string_literal: true

require 'test_helper'

class MaintainRoomMembersTest < TCWithMocks
  include ActiveJob::TestHelper

  test 'clear runs after the heartbeat key expires' do
    stub_const('MaintainRoomMembers::HEARTBEAT_TTL', 10) # the test env one (1) is shorter than any sane delay
    freeze_time do
      MaintainRoomMembers.schedule_clear(1)
      job = enqueued_jobs.find { _1[:job] == MaintainRoomMembersJob }
      assert_operator Time.zone.at(job[:at]), :>, 10.seconds.from_now
    end
  end
end
