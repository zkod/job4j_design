package ru.job4j.collection.analyze;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

/**
 * Класс для тестирования анализатора коллекций.
 */
public class AnalyzeTest {
    /**
     * Тестируем определение сколько добавленно новых пользователей в список.
     */
    @Test
    public void whenListAddNewUsersThenGetCountHowMuchAdd() {
        var previous = List.of(
                new Analyze.User("Veronika"),
                new Analyze.User("Alex"),
                new Analyze.User("Julia"),
                new Analyze.User("Katya")
        );
        var current = new ArrayList<>(previous);
        current.addAll(List.of(
                new Analyze.User("Olga"),
                new Analyze.User("Kristina")
        ));
        var info = Analyze.diff(previous, current);
        assertThat(info.getAdded(), is(2));
        assertThat(info.getDeleted(), is(0));
        assertThat(info.getChanged(), is(0));
    }

    /**
     * Тестируем определение сколько изменено пользователей.
     */
    @Test
    public void whenListEditUsersThenGetCountHowMuchEdit() {
        var previous = List.of(
                new Analyze.User("Veronika"),
                new Analyze.User("Alex"),
                new Analyze.User("Julia"),
                new Analyze.User("Katya")
        );
        var current = new ArrayList<>(previous);
        var user = new Analyze.User("Olga");
        user.setId(current.get(1).getId());
        current.set(1, user);
        user = new Analyze.User("Kristina");
        user.setId(current.get(2).getId());
        current.set(2, user);
        var info = Analyze.diff(previous, current);
        assertThat(info.getAdded(), is(0));
        assertThat(info.getDeleted(), is(0));
        assertThat(info.getChanged(), is(2));
    }

    /**
     * Тестируем определение сколько удалено пользователей.
     */
    @Test
    public void whenListDeleteUsersThenGetCountHowMuchDelete() {
        var previous = List.of(
                new Analyze.User("Veronika"),
                new Analyze.User("Alex"),
                new Analyze.User("Julia"),
                new Analyze.User("Katya")
        );
        var current = new ArrayList<>(previous);
        current.remove(1);
        current.remove(2);
        var info = Analyze.diff(previous, current);
        assertThat(info.getAdded(), is(0));
        assertThat(info.getDeleted(), is(2));
        assertThat(info.getChanged(), is(0));
    }

    /**
     * Тестируем определение сколько добавлено, удалено и изменено пользователей.
     */
    @Test
    public void whenListAddAndEditAndDeleteUsersThenGetCountHowMuchAddAndEditAndDelete() {
        var previous = List.of(
                new Analyze.User("Veronika"),
                new Analyze.User("Alex"),
                new Analyze.User("Julia"),
                new Analyze.User("Katya"),
                new Analyze.User("Dasha"),
                new Analyze.User("Nasty")
        );
        var current = new ArrayList<>(previous);
        current.addAll(List.of(
                new Analyze.User("Olga"),
                new Analyze.User("Kristina")
        ));
        current.remove(4);
        current.remove(4);
        var user = new Analyze.User(current.get(1).getId(), "Olga");
        current.set(1, user);
        user = new Analyze.User(current.get(2).getId(), "Kristina");
        current.set(2, user);
        var info = Analyze.diff(previous, current);
        assertThat(info.getAdded(), is(2));
        assertThat(info.getDeleted(), is(2));
        assertThat(info.getChanged(), is(2));
    }
}