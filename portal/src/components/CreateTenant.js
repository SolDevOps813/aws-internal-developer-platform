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
