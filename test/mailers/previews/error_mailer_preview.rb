# Preview all emails at http://localhost:3000/rails/mailers/error_mailer
class ErrorMailerPreview < ActionMailer::Preview
  ERROR_MAILER_HASH = {
    ip: "10.10.45.47",
    remote_ip: "205.145.45.47",
    original_fullpath: "/carts/1337?other_param=dangerous&sql_injection=DROP%20TABLE%20orders",
    fullpath: "/carts/1337?other_param=dangerous&sql_injection=DROP%20TABLE%20orders",
    method: "DELETE",
    protocol: "https://",
    params: {
      other_param: "dangerous",
      sql_injection: "DROP TABLE orders",
      controller: "carts",
      action: "delete",
      id: "1337"
    }
  }
  # Preview this email at http://localhost:3000/rails/mailers/error_mailer/invalid_cart
  def invalid_cart
    ErrorMailer.invalid_cart(ERROR_MAILER_HASH, Time.current)
  end
end
