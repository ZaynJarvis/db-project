DROP TABLE IF EXISTS TXN, OFFER, COMMENT_MENTION_STOCK, COMMENT, STOCK_PRICE, STOCK, TRADER;

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

CREATE TABLE IF NOT EXISTS TRADER (
    trader_id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL,
    money DECIMAL(15,2) NOT NULL,
    CONSTRAINT trader_pk PRIMARY KEY (trader_id)
);

INSERT INTO TRADER(name, phone, email, password, money) VALUES
("Alice", "1002-9003", "alice@x.com", "xxx", 3000.00), 
("Blice", "2002-9003", "blice@x.com", "xxx", 4000.00), 
("Clice", "3002-9003", "clice@x.com", "xxx", 5000.00),
("Dlice", "4002-9003", "dlice@x.com", "xxx", 3400.00), 
("Elice", "5002-9003", "elice@x.com", "xxx", 3200.00), 
("Flice", "6002-9003", "flice@x.com", "xxx", 3100.00) 
;

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

INSERT INTO OFFER(quantity, buy, sell, offer_status, offer_time, price, stock_id, trader_id) VALUES
(40, 0, 1, 'TRADING', '1980-12-12 02:40:00', '100.90', 'AAPL', NULL),
(10, 1, 0, 'DONE', '1980-12-12 04:40:00', '100.90', 'AAPL', 1),
(30, 0, 1, 'CREATED', '1980-12-13 03:50:00', '100.30', 'AAPL', 2),
(10, 1, 0, 'CREATED', '1980-12-14 04:30:00', '95.00', 'AAPL', 2),
(20, 0, 1, 'CREATED', '1997-05-15 06:30:00', '180.10', 'AMZN', 2),
(10, 1, 0, 'TRADING', '2010-06-29 04:30:00', '190.30', 'TSLA', 3),
(5, 0, 1, 'DONE', '2010-06-29 04:32:00', '189.00', 'TSLA', 4)
;

CREATE INDEX OFFER_ON_STOCK_IDX ON TXN(txn_time);

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

CREATE INDEX TXN_TIME_IDX ON TXN(txn_time);

INSERT INTO TXN(buy_offer_id, sell_offer_id, price, quantity, txn_time) VALUES
(1, 2, 10.3, 10, "1980-12-12 12:40:00"),
(6, 7, 189, 5, '2010-06-29 04:32:00')
;

CREATE TABLE IF NOT EXISTS COMMENT (
    comment_id INTEGER NOT NULL AUTO_INCREMENT,
    content VARCHAR(255) NOT NULL,
    comment_time TIMESTAMP NOT NULL,
    trader_id INTEGER NOT NULL,
    CONSTRAINT pk PRIMARY KEY (comment_id),
    CONSTRAINT comment_fk FOREIGN KEY (trader_id) REFERENCES TRADER(trader_id)
);

INSERT INTO COMMENT(content, comment_time, trader_id) VALUES
("$AAPL I love the stock", "2010-07-29 12:30:00", 1),
("$AAPL buy the dip!!!", "2010-08-29 12:30:00", 1),
("$AAPL diamond hands!", "2011-06-29 12:30:00", 2),
("$TSLA no news currently", "2020-06-29 12:30:00", 3),
("$TSLA $AMZN up up up", "2021-06-29 12:30:00", 5)
;

CREATE TABLE IF NOT EXISTS COMMENT_MENTION_STOCK (
    relationship_id INTEGER NOT NULL AUTO_INCREMENT,
    comment_id INTEGER NOT NULL,
    stock_id VARCHAR(10) NOT NULL,
    CONSTRAINT pk PRIMARY KEY (relationship_id),
    CONSTRAINT rel_fk1 FOREIGN KEY (comment_id) REFERENCES COMMENT(comment_id),
    CONSTRAINT rel_fk2 FOREIGN KEY (stock_id) REFERENCES STOCK(stock_id)
);

INSERT INTO COMMENT_MENTION_STOCK(comment_id, stock_id) VALUES
(1, "AAPL"),
(2, "AAPL"),
(3, "AAPL"),
(4, "TSLA"),
(5, "TSLA"),
(5, "AMZN")
;

CREATE INDEX TXN_TIME_IDX ON TXN(txn_time);
CREATE INDEX STOCK_IPO_IDX ON STOCK(IPO_date);