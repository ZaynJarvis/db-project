/* a: get info of a stock and all its historical prices */
SELECT * FROM stock WHERE stock_id = 'AAPL';
SELECT stock_id, price, record_time FROM STOCK_PRICE WHERE stock_id = 'AAPL';

/* b: get transactions of a stock and show its buyer and seller */
SELECT txn.price, txn.quantity, txn_time, buy_offer.stock_id, buy_offer.trader_id as buyer, sell_offer.trader_id as seller
FROM (txn
JOIN offer as buy_offer ON txn.buy_offer_id = buy_offer.offer_id)
LEFT JOIN offer as sell_offer ON txn.sell_offer_id = sell_offer.offer_id
WHERE buy_offer.stock_id = 'AAPL';

/* c: rank the total transacted volume, get top 3 */
/* For MySQL: */
SELECT stock_id, SUM(txn.quantity) as volume
FROM txn
LEFT JOIN offer ON txn.buy_offer_id=offer.offer_id
GROUP BY stock_id
ORDER BY volume DESC LIMIT 3;

/* For Access: */
-- SELECT TOP 3 stock_id, SUM(txn.quantity) as volume
-- FROM txn
-- LEFT JOIN offer ON txn.buy_offer_id=offer.offer_id
-- GROUP BY stock_id
-- ORDER BY SUM(txn.quantity) DESC;

/* d: Find traders who used to trade apple stocks 
and except from apple stocks, what other stocks they are 
trading or have traded before */
SELECT * FROM offer WHERE trader_id IN
(SELECT trader_id FROM offer WHERE stock_id = 'AAPL')
AND stock_id <> 'AAPL';

/* e: Get all comments that mentioned apple stock */
SELECT comment.comment_id, user_id, content, comment_time 
FROM comment
JOIN comment_mention_stock
ON comment.comment_id = comment_mention_stock.comment_id
WHERE comment_mention_stock.stock_id = 'AAPL';
