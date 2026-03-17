// #Create Service

async function createService() {

  const tenant = document.getElementById("tenant").value
  const service = document.getElementById("service").value

  await fetch(API_BASE + "/create-service", {

    method: "POST",

    headers: {
      "Content-Type": "application/json"
    },

    body: JSON.stringify({
      tenant: tenant,
      service: service
    })

  })

  alert("Service creation started")

}

//#Create Tenant
async function createTenant() {

  const tenant = document.getElementById("newTenant").value

  await fetch(API_BASE + "/create-tenant", {

    method: "POST",

    headers: {
      "Content-Type": "application/json"
    },

    body: JSON.stringify({
      tenant: tenant
    })

  })

  alert("Tenant created")

}

// List Serviced
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

function login() {
// Login Logic
window.location.href =
`${config.COGNITO_DOMAIN}/login?response_type=code&client_id=${config.CLIENT_ID}&redirect_uri=${config.REDIRECT_URI}`

}

// LogoutLogic
function logout() {

window.location.href =
`${config.COGNITO_DOMAIN}/logout?client_id=${config.CLIENT_ID}&logout_uri=${config.REDIRECT_URI}`

}
