require 'application_system_test_case'

class My::PauseUserTracksTest < ApplicationSystemTestCase
  test 'pauses the user track' do
    user = create(:user, :onboarded)
    track = create(:track, title: "Ruby")
    user_track = create :user_track, user: user, track: track

    sign_in!(user)
    visit my_track_path(user_track.track)
    click_on "Pause track"
    within("#modal") do
      click_on "Pause track"
    end

    assert user_track.reload.paused?
  end

  test 'unpauses the user track' do
    user = create(:user, :onboarded)
    track = create(:track, title: "Ruby")
    user_track = create :user_track, user: user, track: track, paused_at: Time.current

    sign_in!(user)
    visit my_track_path(user_track.track)
    within("#modal") do
      click_on "Unpause the #{track.title} Track"
    end
    refute_selector "#modal"

    refute user_track.reload.paused?
  end

  test 'cancels unpausing the user track' do
    user = create(:user, :onboarded)
    track = create(:track, title: "Ruby")
    user_track = create :user_track, user: user, track: track, paused_at: Time.current

    sign_in!(user)
    visit my_track_path(user_track.track)
    within("#modal") do
      click_on "Cancel"
    end
    assert_selector "body.namespace-my.controller-tracks.action-index"
    assert user_track.reload.paused?
  end
end
