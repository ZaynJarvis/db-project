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
