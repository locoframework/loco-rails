# frozen_string_literal: true

require 'test_helper'

module Loco
  # a job enqueued as Loco::SenderJob before the rename must still run
  class SenderJobTest < TCWithMocks
    test 'runs a job enqueued under the old name, with a deprecation warning' do
      job_data = BroadcastJob.new('uuid1', { 'loco' => {} }).serialize.merge('job_class' => 'Loco::SenderJob')
      broadcast = instance_double(Broadcast)
      expect(Broadcast).to receive(:new).with('uuid1').and_return(broadcast)
      expect(broadcast).to receive(:call).with({ 'loco' => {} })
      assert_deprecated(/Loco::BroadcastJob/, DEPRECATOR) { ActiveJob::Base.execute(job_data) }
    end
  end
end
