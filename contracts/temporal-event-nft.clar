;; Temporal Event NFT Contract

(define-non-fungible-token temporal-event-nft uint)

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_INVALID_NFT (err u101))

;; Data variables
(define-data-var last-token-id uint u0)

;; Data maps
(define-map token-metadata
  uint
  {
    creator: principal,
    event-type: (string-ascii 50),
    description: (string-utf8 500),
    timestamp: uint,
    significance: uint,
    related-anomaly: (optional uint)
  }
)

;; Public functions
(define-public (mint-temporal-event (event-type (string-ascii 50)) (description (string-utf8 500)) (timestamp uint) (significance uint) (related-anomaly (optional uint)))
  (let
    (
      (token-id (+ (var-get last-token-id) u1))
    )
    (asserts! (and (>= significance u0) (<= significance u100)) ERR_NOT_AUTHORIZED)
    (try! (nft-mint? temporal-event-nft token-id tx-sender))
    (map-set token-metadata
      token-id
      {
        creator: tx-sender,
        event-type: event-type,
        description: description,
        timestamp: timestamp,
        significance: significance,
        related-anomaly: related-anomaly
      }
    )
    (var-set last-token-id token-id)
    (ok token-id)
  )
)

(define-public (transfer-temporal-event (token-id uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender (unwrap! (nft-get-owner? temporal-event-nft token-id) ERR_INVALID_NFT)) ERR_NOT_AUTHORIZED)
    (try! (nft-transfer? temporal-event-nft token-id tx-sender recipient))
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-temporal-event-metadata (token-id uint))
  (map-get? token-metadata token-id)
)

(define-read-only (get-temporal-event-owner (token-id uint))
  (nft-get-owner? temporal-event-nft token-id)
)

(define-read-only (get-last-token-id)
  (var-get last-token-id)
)

