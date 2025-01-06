;; Paradox Resolution Token Contract

(define-fungible-token paradox-resolution-token)

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_INSUFFICIENT_BALANCE (err u101))

;; Public functions
(define-public (mint-tokens (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_NOT_AUTHORIZED)
    (ft-mint? paradox-resolution-token amount recipient)
  )
)

(define-public (transfer-tokens (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) ERR_NOT_AUTHORIZED)
    (try! (ft-transfer? paradox-resolution-token amount sender recipient))
    (ok true)
  )
)

(define-public (burn-tokens (amount uint) (owner principal))
  (begin
    (asserts! (is-eq tx-sender owner) ERR_NOT_AUTHORIZED)
    (try! (ft-burn? paradox-resolution-token amount owner))
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-balance (account principal))
  (ft-get-balance paradox-resolution-token account)
)

(define-read-only (get-total-supply)
  (ft-get-supply paradox-resolution-token)
)

