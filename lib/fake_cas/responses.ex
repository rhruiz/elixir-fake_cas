defmodule FakeCas.Responses do
  def failure do
    """
    <?xml version="1.0"?>
    <cas:serviceResponse xmlns:cas="http://www.yale.edu/tp/cas">
      <cas:authenticationFailure code="INVALID_SERVICE">
        ticket 'X' is invalid
      </cas:authenticationFailure>
    </cas:serviceResponse>
    """
  end

  def success do
    """
    <?xml version="1.0"?>
    <cas:serviceResponse xmlns:cas="http://www.yale.edu/tp/cas">
      <cas:authenticationSuccess>
        <cas:user>example</cas:user>
        <cas:type>Customer</cas:type>
        <cas:attributes>
          <cas:authorities>[ACME_ADMIN]</cas:authorities>
          <cas:cn>John Smith</cas:cn>
        </cas:attributes>
      </cas:authenticationSuccess>
    </cas:serviceResponse>
    """
  end
end
