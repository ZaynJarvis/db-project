-- Table creation
DROP TABLE IF EXISTS TXN, OFFER, COMMENT_MENTION_STOCK, COMMENT, STOCK_PRICE, STOCK, TRADER, USER;

CREATE TABLE IF NOT EXISTS STOCK (
    stock_id VARCHAR(10) NOT NULL,
    company_name VARCHAR(40) NOT NULL,
    description VARCHAR(255),
    IPO_date DATE NOT NULL,
    total_stock INTEGER NOT NULL,
    CONSTRAINT stock_pk PRIMARY KEY (stock_id)
);

CREATE TABLE IF NOT EXISTS STOCK_PRICE (
    stock_id VARCHAR(10) NOT NULL,
    record_time DATE NOT NULL,
    price DOUBLE NOT NULL,
    CONSTRAINT stock_price_pk PRIMARY KEY (stock_id, record_time),
    CONSTRAINT stock_price_fk FOREIGN KEY (stock_id) REFERENCES STOCK(stock_id)
);


CREATE TABLE IF NOT EXISTS USER (
    user_id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL,
    user_type VARCHAR(10) NOT NULL,
    CONSTRAINT user_pk PRIMARY KEY (user_id)
);

CREATE TABLE IF NOT EXISTS TRADER (
    trader_id INTEGER NOT NULL,
    deposit DECIMAL(15,2) NOT NULL,
    unreal_profit DECIMAL(15,2) NOT NULL, /* unrealized_profit */
    real_profit DECIMAL(15,2) NOT NULL,
    credit_limit DECIMAL(15,2) NOT NULL,
    CONSTRAINT trader_pk PRIMARY KEY (trader_id),
    CONSTRAINT trader_fk FOREIGN KEY (trader_id) REFERENCES USER(user_id)
);

CREATE TABLE IF NOT EXISTS OFFER (
    offer_id INTEGER NOT NULL AUTO_INCREMENT,
    quantity INTEGER NOT NULL,
    buy BOOLEAN NOT NULL,
    sell BOOLEAN NOT NULL,
    offer_status VARCHAR(20) NOT NULL,
    offer_time TIMESTAMP NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    stock_id VARCHAR(10) NOT NULL,
    trader_id INTEGER, /* company can create offer, only stock_id is needed */
    CONSTRAINT pk PRIMARY KEY (offer_id),
    CONSTRAINT offer_fk1 FOREIGN KEY (stock_id) REFERENCES STOCK(stock_id),
    CONSTRAINT offer_fk2 FOREIGN KEY (trader_id) REFERENCES TRADER(trader_id)
);

CREATE TABLE IF NOT EXISTS TXN (
    txn_id INTEGER NOT NULL AUTO_INCREMENT,
    buy_offer_id INTEGER NOT NULL,
    sell_offer_id INTEGER NOT NULL,
    price DOUBLE NOT NULL,
    quantity INTEGER NOT NULL,
    txn_time TIMESTAMP NOT NULL,
    CONSTRAINT pk PRIMARY KEY (txn_id),
    CONSTRAINT txn_fk1 FOREIGN KEY (buy_offer_id) REFERENCES OFFER(offer_id),
    CONSTRAINT txn_fk2 FOREIGN KEY (sell_offer_id) REFERENCES OFFER(offer_id)
);

CREATE TABLE IF NOT EXISTS COMMENT (
    comment_id INTEGER NOT NULL AUTO_INCREMENT,
    content VARCHAR(255) NOT NULL,
    comment_time TIMESTAMP NOT NULL,
    user_id INTEGER NOT NULL,
    CONSTRAINT pk PRIMARY KEY (comment_id),
    CONSTRAINT comment_fk FOREIGN KEY (user_id) REFERENCES USER(user_id)
);

CREATE TABLE IF NOT EXISTS COMMENT_MENTION_STOCK (
    relationship_id INTEGER NOT NULL AUTO_INCREMENT,
    comment_id INTEGER NOT NULL,
    stock_id VARCHAR(10) NOT NULL,
    CONSTRAINT pk PRIMARY KEY (relationship_id),
    CONSTRAINT rel_fk1 FOREIGN KEY (comment_id) REFERENCES COMMENT(comment_id),
    CONSTRAINT rel_fk2 FOREIGN KEY (stock_id) REFERENCES STOCK(stock_id)
);

INSERT INTO STOCK VALUES
("AAPL", "Apple Inc.", "electronic", "1980/12/12", 1000000),
("AMZN", "Amazon Inc.", "e-commerce", "1997/05/15", 1000000),
("FB", "Facebook Inc.", "social media", "2012/05/18", 1000000),
("TSLA", "Tesla Inc.", "electric car", "2010/06/29", 1000000),
("SE", "Sea Inc.", "internet", "2017/10/01", 1000000)
;

INSERT INTO STOCK_PRICE VALUES
("AAPL", "1980-12-12", 100),
("AAPL", "1980-12-13", 101),
("AAPL", "1980-12-14", 105),
("AMZN", "1997-05-15", 100),
("FB", "2012-05-18", 10),
("TSLA", "2010-06-29", 70),
("SE", "2017-10-01", 80),
("SE", "2017-10-02", 90),
("SE", "2017-10-03", 100)
;

INSERT INTO USER(name, phone, email, password, user_type) VALUES
("Alice", "1002-9003", "alice@x.com", "xxx", "trader"), 
("Blice", "2002-9003", "blice@x.com", "xxx", "trader"), 
("Clice", "3002-9003", "clice@x.com", "xxx", "trader"),
("Dlice", "4002-9003", "dlice@x.com", "xxx", "trader"), 
("Elice", "5002-9003", "elice@x.com", "xxx", "trader"), 
("Flice", "6002-9003", "flice@x.com", "xxx", "viewer") 
;

INSERT INTO TRADER(trader_id, deposit, unreal_profit, real_profit, credit_limit) VALUES
(1, 3000.00, 100, 100, 0), 
(2, 4000.00, 0, -100, 1000), 
(3, 5000.00, -200, 100, 200),
(4, 3400.00, 100, 200, 3000),
(5, 3200.00, 1000, 200, 2000)
;

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
(5, 1, 0, 'DONE', '2013-07-29 06:32:00', '100.00', 'AMZN', 2)
;

INSERT INTO TXN(buy_offer_id, sell_offer_id, price, quantity, txn_time) VALUES
(2, 1, 10.3, 10, "1980-12-12 12:40:00"),
(6, 7, 189, 5, '2010-06-29 04:32:00'),
(9, 8, 100, 10, '2013-07-29 05:32:00'),
(10, 8, 100, 5, '2013-07-29 06:32:00')
;

INSERT INTO COMMENT(content, comment_time, user_id) VALUES
("$AAPL I love the stock", "2010-07-29 12:30:00", 1),
("$AAPL buy the dip!!!", "2010-08-29 12:30:00", 1),
("$AAPL diamond hands!", "2011-06-29 12:30:00", 2),
("$TSLA no news currently", "2020-06-29 12:30:00", 3),
("$TSLA $AMZN up up up", "2021-06-29 12:30:00", 5)
;

INSERT INTO COMMENT_MENTION_STOCK(comment_id, stock_id) VALUES
(1, "AAPL"),
(2, "AAPL"),
(3, "AAPL"),
(4, "TSLA"),
(5, "TSLA"),
(5, "AMZN")
;

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

CREATE INDEX STOCK_IPO_IDX ON STOCK(IPO_date);
CREATE INDEX USER_NAME_IDX ON USER(name);

SELECT company_name, IPO_date FROM STOCK 
WHERE IPO_date BETWEEN "2012/01/01" AND "2020/01/01";
EXPLAIN SELECT company_name, IPO_date FROM STOCK 
WHERE IPO_date BETWEEN "2012/01/01" AND "2020/01/01";

SELECT name, email FROM USER WHERE name LIKE "F%";
EXPLAIN SELECT name, email FROM USER WHERE name LIKE "F%";
