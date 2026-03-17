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
