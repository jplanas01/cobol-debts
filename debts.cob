       identification division.
       program-id. debts.

       environment division.
       input-output section.
       file-control.
           select debts-file assign to "debts.dat" 
               organization is relative
               access mode is dynamic
               relative key is debt-id
               file status debt-file-status.

       data division.
       file section.
       fd debts-file
           data record is debt-entry.
       01 debt-entry.
           02 name pic X(20).
           02 amount pic 9(5).
           02 paid pic 9(5).
           02 debt-date.
               03 day-of pic 99.
               03 month-of pic 99.
               03 year-of pic 9(4).
           02 description pic X(40).
           02 debt-currency pic A(3).
           02 is-mine pic 9.
           02 newline-filler pic X value X"0A".
       working-storage section.
       01 debt-id pic 99.
       01 debt-file-status pic XX.
       01 debt-count pic 99.
       01 records-left pic 9 value 1.
           88 no-more-records value 0.
       01 input-valid pic 9 value 0.


       screen section.
       01 clear-screen.
           02 blank screen.

       01 debt-input-screen.
           02 value "Debtor name:" line 2 column 6.
           02 input-name line 2 column 40 to name.
           02 value "Amount:" line 3 column 6.
           02 input-amount line 3 column 40 to amount.
           02 value "Description:" line 4 column 6.
           02 input-description line 4 column 40 to description.
           02 value "Currency (USD/DOP):" line 5 column 6.
           02 input-currency line 5 column 40 to debt-currency.
           02 value "Mine? (0 for no, 1 for yes)" line 6 column 6.
           02 input-mine line 6 column 40 to is-mine.


       procedure division.
      *> Why does VALUES clause not auto initialize newline-filler?
           move X"0A" to newline-filler
           perform find-debt-count
           perform get-debt-input
      *display debt-count
      *perform write-test-records
       goback.

       validate-current-entry.
           move 1 to input-valid
           .

       write-current-entry.
           open output debts-file
           write debt-entry
           close debts-file
           .

       get-debt-input.
           display clear-screen
           display debt-input-screen
           accept debt-input-screen.
           move function upper-case(debt-currency) to debt-currency
           .

       find-debt-count.
           move 0 to debt-count
           move 1 to records-left

           open input debts-file
           read debts-file
               at end set records-left to 0
           end-read
           perform until no-more-records
               add 1 to debt-count
               read debts-file
                   at end set records-left to 0
               end-read
           end-perform
           close debts-file.

       write-test-records.
           move "philbert" to name
           move 999 to amount
           move 0 to paid
           move 01 to day-of
           move 01 to month-of
           move 1999 to year-of
           move "test record" to description
           move "USD" to debt-currency
           move 0 to is-mine
           move 5 to debt-count
           move 1 to debt-id

           open output debts-file
           perform debt-count times
               write debt-entry
               add 1 to debt-id
               display "hello!"
           end-perform.
           close debts-file.
       end program debts.

