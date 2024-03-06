from product import Product
from pydantic import BaseModel
from datetime import datetime
from typing import List
from fastapi import APIRouter, Response
from database import name as database_name, pool

READ_ORDERS_QUERY = """
select `order`.*, product.id AS product_id, product.name, product.price, product.width, product.height, product.depth, product.weight, order_product.quantity
from `order` inner join order_product on order.id = order_product.order_id inner join product on order_product.product_id=product.id
"""
READ_ORDER_BY_ID = """
 select `order`.*, product.id AS product_id, product.name, product.price, product.width, product.height,
product.depth, product.weight, order_product.quantity from `order` inner join order_product on order.id = order_product.order_id inner join product on order_product.product_id=product.id where `order`.id=(?);
"""
CREATE_ORDER_BY_ORDER_ID = """
insert into `order` values ();
insert into order_product values ((select max(id) from `order`), ?, ?);
"""
DELETE_ORDER_BY_ID = """
DELETE FROM `order` where id=(?)
"""


class Order(BaseModel):
    id: int
    datetime: datetime
    status: str
    products: List[Product]


class DatabaseOrderRepository:
    def __init__(self, connection):
        self.connection = connection

    def list(self):
        cur = self.connection.cursor()
        cur.execute(READ_ORDERS_QUERY)
        orders = {}
        for (
            id,
            datetime,
            status,
            product_id,
            name,
            price,
            width,
            height,
            depth,
            weight,
            quantity,
        ) in cur:
            if id not in orders:
                orders[id] = Order(id=id, datetime=datetime, status=status, products=[])
            orders[id].products.append(
                Product(
                    id=product_id,
                    name=name,
                    price=price,
                    width=width,
                    height=height,
                    depth=depth,
                    weight=weight,
                    quantity=quantity,
                )
            )
        return list(orders.values())

    def get(self, id):
        cur = self.connection.cursor()
        cur.execute(READ_ORDER_BY_ID, (id,))
        products = {}
        for (
            id,
            datetime,
            status,
            product_id,
            name,
            price,
            width,
            height,
            depth,
            weight,
            quantity,
        ) in cur:
            if id not in products:
                products[id] = []
                order = Order(id=id, datetime=datetime, status=status, products=[])
            products[id].append(
                Product(
                    id=product_id,
                    name=name,
                    price=price,
                    width=width,
                    height=height,
                    depth=depth,
                    weight=weight,
                    quantity=quantity,
                )
            )
        order.products = products[id]
        return order

    def create(self, product_id, quantity):
        cur = self.connection.cursor()
        cur.execute(CREATE_ORDER_BY_ORDER_ID, (product_id, quantity))
        cur.execute("select max(id) from `order`")
        for id in cur:
            return {"order_id": id}

    def delete(self, id):
        cur = self.connection.cursor()
        cur.execute(DELETE_ORDER_BY_ID, (id,))


connection = pool.get_connection()
connection.database = database_name
order_repository = DatabaseOrderRepository(connection)
router = APIRouter()


@router.get("/orders")
def read_orders():
    orders = order_repository.list()
    return orders


@router.get("/orders/{id}")
def read_order(id: int):
    try:
        order = order_repository.get(id)
        return order
    except:
        raise HTTPException(status_code=404)


class OrderModel(BaseModel):
    product_id: int
    quantity: int


@router.post("/orders")
def create_order(model: OrderModel):
    order = order_repository.create(model.product_id, model.quantity)
    return order


@router.delete("/orders/{id}")
def delete_order(id: int):
    try:
        order_repository.delete(id)
    except:
        return HTTPException(status_code=204)
