CREATE TABLE IF NOT EXISTS STOCK (
    stock_id INTEGER NOT NULL,
    company_name VARCHAR(40) NOT NULL,
    description VARCHAR(255),
    IPO_date DATE NOT NULL,
    total_stock INTEGER NOT NULL,
    CONSTRAINT stock_pk PRIMARY KEY (stock_id)
);

CREATE TABLE IF NOT EXISTS STOCK_PRICE (
    stock_id INTEGER NOT NULL,
    record_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    price DOUBLE NOT NULL,
    CONSTRAINT stock_price_pk PRIMARY KEY (stock_id, record_time),
    CONSTRAINT stock_price_fk FOREIGN KEY (stock_id) REFERENCES STOCK(stock_id)
);

INSERT INTO STOCK VALUES
(1, "Apple Inc.", "electronic", "1980/12/12", 1000000),
(2, "Amazon Inc.", "e-commerce", "1997/05/15", 1000000),
(3, "Facebook Inc.", "social media", "2012/05/18", 1000000),
(4, "Tesla Inc.", "electric car", "2010/06/29", 1000000),
(5, "Sea Inc.", "internet", "2017/10/01", 1000000)
;

INSERT INTO STOCK_PRICE VALUES
(1, TIMESTAMP("1980-12-12 19:30:00"), 100),
(1, TIMESTAMP("1980-12-12 19:40:00"), 101),
(1, TIMESTAMP("1980-12-12 19:50:00"), 105),
(2, TIMESTAMP("1997-05-15 19:50:00"), 100),
(3, TIMESTAMP("2012-05-18 19:50:00"), 10),
(4, TIMESTAMP("2010-06-29 19:50:00"), 70),
(5, TIMESTAMP("2017-10-01 19:50:00"), 30),
(5, TIMESTAMP("2017-12-01 19:50:00"), 90),
(5, TIMESTAMP("2018-12-01 19:50:00"), 100)
;

CREATE TABLE IF NOT EXISTS TRADER (
    trader_id INTEGER NOT NULL,
    name VARCHAR(40) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL,
    money DECIMAL(15,2) NOT NULL,
    CONSTRAINT trader_pk PRIMARY KEY (trader_id)
);

INSERT INTO TRADER VALUES
(1, "Alice", "1002-9003", "alice@x.com", 'xxx', 3000.00), 
(2, "Blice", "2002-9003", "blice@x.com", 'xxx', 4000.00), 
(3, "Clice", "3002-9003", "clice@x.com", 'xxx', 5000.00),
(4, "Dlice", "4002-9003", "dlice@x.com", 'xxx', 3400.00), 
(5, "Elice", "5002-9003", "elice@x.com", 'xxx', 3200.00), 
(6, "Flice", "6002-9003", "flice@x.com", 'xxx', 3100.00) 
;

CREATE TABLE IF NOT EXISTS OFFER (
    offer_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    buy BOOLEAN NOT NULL,
    sell BOOLEAN NOT NULL,
    offer_status VARCHAR(20) NOT NULL,
    offer_time TIMESTAMP NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    stock_id INTEGER NOT NULL,
    trader_id INTEGER, /* company can create offer, only stock_id is needed */
    CONSTRAINT pk PRIMARY KEY (offer_id),
    CONSTRAINT offer_fk1 FOREIGN KEY (stock_id) REFERENCES STOCK(stock_id),
    CONSTRAINT offer_fk2 FOREIGN KEY (trader_id) REFERENCES TRADER(trader_id)
);

INSERT INTO OFFER VALUES
(1, 10, true, false, 'CREATED', CURRENT_TIMESTAMP, 10.3, 1, 1),
(2, 30, false, true, 'CREATED', CURRENT_TIMESTAMP, 10.3, 1, 2),
(3, 10, true, false, 'CREATED', CURRENT_TIMESTAMP, 40.3, 1, 2),
(4, 20, false, true, 'CREATED', CURRENT_TIMESTAMP, 80.1, 3, 2),
(5, 10, true, false, 'CREATED', CURRENT_TIMESTAMP, 90.3, 4, 3),
(6, 40, false, true, 'CREATED', CURRENT_TIMESTAMP, 70.9, 1, NULL)
;

/* seller_id and buyer_id are not 3NF 

CREATE TABLE IF NOT EXISTS TXN (
    txn_id INTEGER NOT NULL,
    seller_id INTEGER, 
    buyer_id INTEGER NOT NULL,
    buyer_offer_id INTEGER NOT NULL,
    offer_id INTEGER NOT NULL,
    price DOUBLE NOT NULL,
    quantity INTEGER NOT NULL,
    txn_time TIME NOT NULL,
    CONSTRAINT pk PRIMARY KEY (txn_id),
    CONSTRAINT txn_fk1 FOREIGN KEY (seller_id) REFERENCES TRADER(trader_id),
    CONSTRAINT txn_fk2 FOREIGN KEY (buyer_id) REFERENCES TRADER(trader_id),
    CONSTRAINT txn_fk3 FOREIGN KEY (offer_id) REFERENCES OFFER(offer_id)
);
*/

CREATE TABLE IF NOT EXISTS TXN (
    txn_id INTEGER NOT NULL,
    buy_offer_id INTEGER NOT NULL,
    sell_offer_id INTEGER NOT NULL,
    price DOUBLE NOT NULL,
    quantity INTEGER NOT NULL,
    txn_time TIME NOT NULL,
    CONSTRAINT pk PRIMARY KEY (txn_id),
    CONSTRAINT txn_fk1 FOREIGN KEY (buy_offer_id) REFERENCES OFFER(offer_id),
    CONSTRAINT txn_fk2 FOREIGN KEY (sell_offer_id) REFERENCES OFFER(offer_id)
);

INSERT INTO TXN VALUES
(1, 1, 2, 10.3, 10, CURRENT_TIMESTAMP)
;

CREATE TABLE IF NOT EXISTS COMMENT (
    comment_id INTEGER NOT NULL,
    content VARCHAR(255) NOT NULL,
    comment_time TIMESTAMP NOT NULL,
    trader_id INTEGER NOT NULL,
    CONSTRAINT pk PRIMARY KEY (comment_id),
    CONSTRAINT comment_fk FOREIGN KEY (trader_id) REFERENCES TRADER(trader_id)
);

INSERT INTO COMMENT VALUES
(1, 'I love the stock', CURRENT_TIMESTAMP, 1),
(2, 'buy the dip!!!', CURRENT_TIMESTAMP, 1),
(3, 'diamond hands!', CURRENT_TIMESTAMP, 2),
(4, 'no news currently', CURRENT_TIMESTAMP, 3),
(5, 'up up up', CURRENT_TIMESTAMP, 5)
;

CREATE TABLE IF NOT EXISTS COMMENT_REL (
    relationship_id INTEGER NOT NULL,
    comment_id INTEGER NOT NULL,
    stock_id INTEGER NOT NULL,
    CONSTRAINT pk PRIMARY KEY (relationship_id),
    CONSTRAINT rel_fk1 FOREIGN KEY (comment_id) REFERENCES COMMENT(comment_id),
    CONSTRAINT rel_fk2 FOREIGN KEY (stock_id) REFERENCES STOCK(stock_id)
);

INSERT INTO COMMENT_REL VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1)
;

DROP TABLE IF EXISTS TXN, OFFER, COMMENT_REL, COMMENT, STOCK_PRICE, STOCK, TRADER;
