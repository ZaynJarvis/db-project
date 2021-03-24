INSERT INTO STOCK VALUES
("AAPL", "Apple Inc.", "electronic", "1980/12/12", 1000000),
("AMZN", "Amazon Inc.", "e-commerce", "1997/05/15", 1000000),
("FB", "Facebook Inc.", "social media", "2012/05/18", 1000000),
("TSLA", "Tesla Inc.", "electric car", "2010/06/29", 1000000),
("SE", "Sea Inc.", "internet", "2017/10/01", 1000000);

INSERT INTO STOCK_PRICE VALUES
("AAPL", "1980-12-12", 100),
("AAPL", "1980-12-13", 101),
("AAPL", "1980-12-14", 105),
("AMZN", "1997-05-15", 100),
("FB", "2012-05-18", 10),
("TSLA", "2010-06-29", 70),
("SE", "2017-10-01", 80),
("SE", "2017-10-02", 90),
("SE", "2017-10-03", 100);

INSERT INTO USER(name, phone, email, password, user_type) VALUES
("Alice", "1002-9003", "alice@x.com", "xxx", "trader"), 
("Blice", "2002-9003", "blice@x.com", "xxx", "trader"), 
("Clice", "3002-9003", "clice@x.com", "xxx", "trader"),
("Dlice", "4002-9003", "dlice@x.com", "xxx", "trader"), 
("Elice", "5002-9003", "elice@x.com", "xxx", "trader"), 
("Flice", "6002-9003", "flice@x.com", "xxx", "viewer");

INSERT INTO TRADER(trader_id, deposit, unreal_profit, real_profit, credit_limit) VALUES
(1, 3000.00, 100, 100, 0), 
(2, 4000.00, 0, -100, 1000), 
(3, 5000.00, -200, 100, 200),
(4, 3400.00, 100, 200, 3000),
(5, 3200.00, 1000, 200, 2000);

INSERT INTO OFFER(quantity, buy, sell, offer_status, offer_time, price, stock_id, trader_id) VALUES
(10, 0, 1, 'DONE', '1980-12-12 02:40:00', '100.30', 'AAPL', NULL),
(10, 1, 0, 'DONE', '1980-12-12 04:40:00', '100.30', 'AAPL', 1),
(30, 0, 1, 'DROPPED', '1980-12-13 03:50:00', '100.30', 'AAPL', 2),
(10, 1, 0, 'DROPPED', '1980-12-14 04:30:00', '95.00', 'AAPL', 2),
(20, 0, 1, 'CREATED', '1997-05-15 06:30:00', '180.10', 'AMZN', 2),
(10, 1, 0, 'TRADING', '2010-06-29 04:30:00', '189.00', 'TSLA', 3),
(5, 0, 1, 'DONE', '2010-06-29 04:32:00', '189.00', 'TSLA', 4),
(15, 0, 1, 'DONE', '2013-07-29 04:32:00', '100.00', 'AMZN', 3),
(10, 1, 0, 'DONE', '2013-07-29 05:32:00', '100.00', 'AMZN', 1),
(5, 1, 0, 'DONE', '2013-07-29 06:32:00', '100.00', 'AMZN', 2);

INSERT INTO TXN(buy_offer_id, sell_offer_id, price, quantity, txn_time) VALUES
(2, 1, 10.3, 10, "1980-12-12 12:40:00"),
(6, 7, 189, 5, '2010-06-29 04:32:00'),
(9, 8, 100, 10, '2013-07-29 05:32:00'),
(10, 8, 100, 5, '2013-07-29 06:32:00');

INSERT INTO COMMENT(content, comment_time, user_id) VALUES
("$AAPL I love the stock", "2010-07-29 12:30:00", 1),
("$AAPL buy the dip!!!", "2010-08-29 12:30:00", 1),
("$AAPL diamond hands!", "2011-06-29 12:30:00", 2),
("$TSLA no news currently", "2020-06-29 12:30:00", 3),
("$TSLA $AMZN up up up", "2021-06-29 12:30:00", 5);

INSERT INTO COMMENT_MENTION_STOCK(comment_id, stock_id) VALUES
(1, "AAPL"),
(2, "AAPL"),
(3, "AAPL"),
(4, "TSLA"),
(5, "TSLA"),
(5, "AMZN");
