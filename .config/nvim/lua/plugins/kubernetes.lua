-- Kubernetes: built-in schema; OpenShift / Istio: local JSON schemas.
-- Filename-based matching. Name resources e.g. nginx-service.yaml,
-- app-buildconfig.yaml, reviews-virtualservice.yaml.
local kubernetes_resources = {
  "deployment", "service", "configmap", "secret", "statefulset",
  "daemonset", "job", "cronjob", "ingress", "networkpolicy",
  "persistentvolume", "persistentvolumeclaim", "serviceaccount",
  "role", "rolebinding", "clusterrole", "clusterrolebinding",
  "namespace", "horizontalpodautoscaler", "pod", "poddisruptionbudget",
}

local function patterns(resource)
  local result = {}
  for _, ext in ipairs({ "yaml", "yml" }) do
    -- Use name boundaries so e.g. service doesn't match virtualservice.
    for _, name in ipairs({
      resource,
      "*-" .. resource,
      resource .. "-*",
      "*-" .. resource .. "-*",
      "*_" .. resource,
      resource .. "_*",
      "*_" .. resource .. "_*",
    }) do
      result[#result + 1] = "**/" .. name .. "." .. ext
    end
  end
  return result
end

local function patterns_for(resources)
  local result = {}
  for _, name in ipairs(resources) do
    vim.list_extend(result, patterns(name))
  end
  return result
end

local schemas = { kubernetes = patterns_for(kubernetes_resources) }
local config_dir = vim.fn.stdpath("config")

for _, group in ipairs({ "openshift", "istio", "kustomize" }) do
  local folder = config_dir .. "/schemas/" .. group
  for _, schema in ipairs(vim.fn.globpath(folder, "*.json", false, true)) do
    local resource = vim.fn.fnamemodify(schema, ":t:r")
    if group == "kustomize" then
      -- Kustomize has conventional exact filenames, not arbitrary suffixes.
      schemas[schema] = { "**/" .. resource .. ".yaml", "**/" .. resource .. ".yml", "**/" .. resource .. ".YAML" }
    else
      schemas[schema] = patterns(resource)
    end
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = { schemas = schemas },
          },
        },
      },
    },
  },
}
