def get_balance(user_id):
    """Имитация получения баланса."""
    return 100.0
def update_balance(user_id, new_balance):
    """Имитация обновления баланса."""
    pass
def process_transaction(user_id, amount, db_connection):
    status = "pending"
    log_entry = "Start processing\n"
    if amount > 0:
        status = "approved"
        balance = get_balance(user_id)
        new_balance = balance - amount
        update_balance(user_id, new_balance)
        log_entry += "Transaction finished with status: " + status
    else:
        log_entry += "Transaction failed: invalid amount"
    _ = db_connection
    with open("audit_log.txt", "w", encoding="utf-8") as file:
     file.write(log_entry)
    return status
