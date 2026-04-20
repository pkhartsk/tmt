#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart
    rlPhaseStartSetup
        rlRun "pushd data"
    rlPhaseEnd

    rlPhaseStartTest "Explore Plans"
        rlRun -s "tmt plan"
        rlAssertNotGrep "warn" $rlRun_LOG
        rlAssertGrep "Found 11 plans" $rlRun_LOG
    rlPhaseEnd


    rlPhaseStartTest "Remote plan should not be fetched if disabled by adjust"
        rm -rf '~/.cache/fmf/https:__github.com_teemtee_tmt'
        rlRun -s "tmt -ddd -c distro=rhel-10 -c how=full run --remove --dry plan --name /plans/disabled-by-adjust" 0 "Run enabled plan"
        rlAssertGrep "Plan '/plans/disabled-by-adjust' importing" $rlRun_LOG
        rlAssertNotGrep "Plan '/plans/disabled-by-adjust' is not enabled, skipping imports resolution" $rlRun_LOG
        rlAssertNotGrep "No plans found." $rlRun_LOG

        rm -rf '~/.cache/fmf/https:__github.com_teemtee_tmt'
        rlRun -s "tmt -ddd -c distro=fedora-rawhide -c how=full run --remove --dry plan --name /plans/disabled-by-adjust" 2 "Expect no plans to be found"
        rlAssertNotGrep "Plan '/plans/disabled-by-adjust' importing" $rlRun_LOG
        rlAssertGrep "Plan '/plans/disabled-by-adjust' is not enabled, skipping imports resolution" $rlRun_LOG
        rlAssertGrep "No plans found." $rlRun_LOG

        rlRun -s "tmt -ddd -c distro=fedora-rawhide -c how=full plan show /plans/disabled-by-adjust --shallow" 0 "Show dummy plan"
        rlAssertNotGrep "Plan '/plans/disabled-by-adjust' importing" $rlRun_LOG

        rlRun -s "tmt -ddd -c distro=fedora-rawhide -c how=full plan show /plans/disabled-by-adjust" 0 "Show plan correctly"
        rlAssertGrep "Plan '/plans/disabled-by-adjust' importing" $rlRun_LOG

        rm -rf '~/.cache/fmf/https:__github.com_teemtee_tmt'
        rlRun -s "tmt -ddd -c distro=fedora-rawhide -c how=full plan ls /plans/disabled-by-adjust" 0 "List disabled plan"
        rlAssertGrep "Plan '/plans/disabled-by-adjust' importing" $rlRun_LOG
        rlAssertNotGrep "Plan '/plans/disabled-by-adjust' is not enabled, skipping imports resolution" $rlRun_LOG
        rlAssertEquals "Verify last line is the plan" "/plans/disabled-by-adjust" $(tail -1 $rlRun_LOG)

        rm -rf '~/.cache/fmf/https:__github.com_teemtee_tmt'
        rlRun -s "tmt -ddd -c distro=fedora-rawhide -c how=full plan ls /plans/disabled-by-adjust --enabled" 0 "Do not list with --enabled option"
        rlAssertNotGrep "Plan '/plans/disabled-by-adjust' importing" $rlRun_LOG
        rlAssertGrep "Plan '/plans/disabled-by-adjust' is not enabled, skipping imports resolution" $rlRun_LOG
        rlAssertNotEquals "Verify last line is not the plan" "/plans/disabled-by-adjust" $(tail -1 $rlRun_LOG)
    rlPhaseEnd

    rlPhaseStartTest "Disabled remote plan should be fetched if enabled by adjust"
        rm -rf '~/.cache/fmf/https:__github.com_teemtee_tmt'
        rlRun -s "tmt -ddd -c distro=fedora-rawhide -c how=full run --remove --dry plan --name /plans/enabled-by-adjust" 0 "Run enabled plan"
        rlAssertGrep "Plan '/plans/enabled-by-adjust' importing" $rlRun_LOG
        rlAssertNotGrep "Plan '/plans/enabled-by-adjust' is not enabled, skipping imports resolution" $rlRun_LOG
        rlAssertNotGrep "No plans found." $rlRun_LOG

        rm -rf '~/.cache/fmf/https:__github.com_teemtee_tmt'
        rlRun -s "tmt -ddd -c distro=rhel-10 -c how=full run --remove --dry plan --name /plans/enabled-by-adjust" 2 "Expect no plans to be found"
        rlAssertNotGrep "Plan '/plans/enabled-by-adjust' importing" $rlRun_LOG
        rlAssertGrep "Plan '/plans/enabled-by-adjust' is not enabled, skipping imports resolution" $rlRun_LOG
        rlAssertGrep "No plans found." $rlRun_LOG

        rlRun -s "tmt -ddd -c distro=rhel-10 -c how=full plan show /plans/enabled-by-adjust --shallow" 0 "Show dummy plan"
        rlAssertNotGrep "Plan '/plans/enabled-by-adjust' importing" $rlRun_LOG

        rlRun -s "tmt -ddd -c distro=rhel-10 -c how=full plan show /plans/enabled-by-adjust" 0 "Show plan correctly"
        rlAssertGrep "Plan '/plans/enabled-by-adjust' importing" $rlRun_LOG

        rm -rf '~/.cache/fmf/https:__github.com_teemtee_tmt'
        rlRun -s "tmt -ddd -c distro=rhel-10 -c how=full plan ls /plans/enabled-by-adjust" 0 "List disabled plan"
        rlAssertGrep "Plan '/plans/enabled-by-adjust' importing" $rlRun_LOG
        rlAssertNotGrep "Plan '/plans/enabled-by-adjust' is not enabled, skipping imports resolution" $rlRun_LOG
        rlAssertEquals "Verify last line is the plan" "/plans/enabled-by-adjust" $(tail -1 $rlRun_LOG)

        rm -rf '~/.cache/fmf/https:__github.com_teemtee_tmt'
        rlRun -s "tmt -ddd -c distro=rhel-10 -c how=full plan ls /plans/enabled-by-adjust --enabled" 0 "List enabled plans"
        rlAssertNotGrep "Plan '/plans/enabled-by-adjust' importing" $rlRun_LOG
        rlAssertGrep "Plan '/plans/enabled-by-adjust' is not enabled, skipping imports resolution" $rlRun_LOG
        rlAssertNotEquals "Verify last line is not the plan" "/plans/enabled-by-adjust" $(tail -1 $rlRun_LOG)

        rlRun -s "tmt -ddd -c distro=fedora-rawhide -c how=full plan ls /plans/enabled-by-adjust --enabled" 0 "List enabled plans with correct environment"
        rlAssertGrep "Plan '/plans/enabled-by-adjust' importing" $rlRun_LOG
        rlAssertNotGrep "Plan '/plans/enabled-by-adjust' is not enabled, skipping imports resolution" $rlRun_LOG
        rlAssertEquals "Verify last line is the plan" "/plans/enabled-by-adjust" $(tail -1 $rlRun_LOG)
    rlPhaseEnd

    rlPhaseStartTest "Unimportable plan should not raise errors when disabled"
        rlRun -s "tmt -ddd -c how=full plan ls /plans/disabled-internal" 2 "Error out when trying to import internal URL"
        rlAssertGrep "Plan '/plans/disabled-internal' importing" $rlRun_LOG
        rlAssertGrep "Failed to import remote plan from '/plans/disabled-internal'" $rlRun_LOG

        rlRun -s "tmt -ddd -c how=full plan ls /plans/disabled-internal --enabled" 0 "Skip disabled plan with --enabled flag"
        rlAssertNotGrep "Plan '/plans/disabled-internal' importing" $rlRun_LOG
        rlAssertNotGrep "Failed to import remote plan from '/plans/disabled-internal'" $rlRun_LOG

        rlRun -s "tmt -ddd -c how=full plan show /plans/disabled-internal" 2 "Error out when showing"
        rlAssertGrep "Plan '/plans/disabled-internal' importing" $rlRun_LOG
        rlAssertGrep "Failed to import remote plan from '/plans/disabled-internal'" $rlRun_LOG

        rlRun -s "tmt -ddd -c how=full plan show /plans/disabled-internal --shallow" 0 "Show dummy plan"
        rlAssertNotGrep "Plan '/plans/disabled-internal' importing" $rlRun_LOG
        rlAssertNotGrep "Failed to import remote plan from '/plans/disabled-internal'" $rlRun_LOG
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "popd"
    rlPhaseEnd
rlJournalEnd
