<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useRoute } from "vue-router";
import CreateTodo from "~/components/CreateTodo.vue"; // Импорт компонента CreateTodo

// Получаем id из адресной строки
const route = useRoute();
const todoId = ref(route.params.id);

const todoExists = ref(false);

onMounted(() => {
  const todos = JSON.parse(localStorage.getItem("todos") || "[]");
  todoExists.value = todos.some((todo: { id: number }) => todo.id === Number(todoId.value));
});
</script>

<template>
  <div class="mb-20">
    <nuxt-link to="/" class="absolute top-4 left-4">
      <span>На главную</span>
    </nuxt-link>
    <h1 class="text-4xl font-semibold text-center my-20">Работа с задачей</h1>
    <div v-if="!todoExists">
      <create-todo :todo-id="todoId" />
    </div>
    <div v-else>
      <change-todo :todo-id="todoId"/>
    </div>
  </div>
</template>

<style scoped>
h1 {
  margin-bottom: 1rem;
}

p {
  color: red;
  font-size: 1.2rem;
}
</style>
