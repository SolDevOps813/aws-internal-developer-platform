async function loadServices() {

  const response = await fetch(API_BASE + "/services")

  const services = await response.json()

  const list = document.getElementById("serviceList")

  list.innerHTML = ""

  services.forEach(service => {

    const li = document.createElement("li")

    li.textContent = service.tenant + " - " + service.service_name

    list.appendChild(li)

  })

}
