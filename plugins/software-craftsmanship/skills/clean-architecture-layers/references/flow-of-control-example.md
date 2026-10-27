# Flow of control example

## Core statement
Control goes controller -> input port -> interactor -> output port -> presenter, while every source dependency points inward. The use case calls an output interface it owns; the presenter implements it, so the dependency opposes the call.

## Symptoms
- The use case imports the presenter or view.
- The controller reaches into entities or the database.
- The presenter (or view) makes business decisions.
- The use case returns a value that a framework must interpret, such as an HTTP response.

## How to apply
Original example (Python, invoice late fee):

```python
from dataclasses import dataclass
from typing import Protocol

@dataclass
class Invoice:                       # entity: rule + data
    amount: float; days_late: int
    def late_fee(self): return round(self.amount * 0.02 * self.days_late, 2)

@dataclass
class FeeRequest: invoice_id: str    # plain input
@dataclass
class FeeResponse: invoice_id: str; fee: float   # plain output

class InvoiceGateway(Protocol):      # data-access port (inner side)
    def get(self, invoice_id: str) -> Invoice: ...
class FeeOutput(Protocol):           # output port (inner side)
    def present(self, r: FeeResponse): ...

class ComputeFee:                    # interactor (implements input port)
    def __init__(self, gw: InvoiceGateway, out: FeeOutput): self.gw, self.out = gw, out
    def run(self, req: FeeRequest):
        fee = self.gw.get(req.invoice_id).late_fee()
        self.out.present(FeeResponse(req.invoice_id, fee))

class FeePresenter:                  # adapter: outer, implements output port
    def present(self, r): self.view = {"text": f"Fee for {r.invoice_id}: ${r.fee:,.2f}"}

def controller(raw: dict, uc: ComputeFee):   # adapter: raw -> plain request
    uc.run(FeeRequest(str(raw["id"])))
```

Notes: only controller, presenter and gateway implementation know the outside world; tests use a dict-backed gateway and a list-collecting output.

## Language and framework notes
- Spring: controller method calls the input-port interface; presenter bean implements output port; return the view model.
- Django/FastAPI: the view/route builds the request, calls the interactor, returns the presenter's view model as the response.
- NestJS/ASP.NET: same shape; the controller returns the presenter's view model; avoid returning entities.
- Rails: controller calls the interactor with a presenter object; renders its view model.
- Simple setups may let the interactor return the response directly instead of an output port; the dependency rule is still met.

## Common over-application
- Output ports on trivial reads where a return value does the job.
- Separate view-model and response classes with identical fields and no formatting.
- One presenter per endpoint when a shared one fits.

## Source
Martin (2017), Ch. 22.
